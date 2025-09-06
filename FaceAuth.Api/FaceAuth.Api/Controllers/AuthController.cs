using FaceAuth.Api.Data;
using FaceAuth.Api.Dtos;
using FaceAuth.Api.Models;
using FaceAuth.Api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FaceAuth.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _db;
    private readonly FaceEmbedderClient _fe;
    private readonly TokenService _tokens;
    private const double Threshold = 0.6;

    public AuthController(AppDbContext db, FaceEmbedderClient fe, TokenService tokens)
    {
        _db = db;
        _fe = fe;
        _tokens = tokens;
    }

    // ============================
    // USERNAME/PASSWORD LOGIN
    // ============================
    [HttpPost("login")]
    public async Task<ActionResult<object>> Login([FromBody] LoginRequest request)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Username == request.Username);
        if (user == null)
            return Unauthorized(new { error = "Invalid username or password" });

        if (!string.IsNullOrWhiteSpace(user.PasswordHash))
        {
            if (!BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
                return Unauthorized(new { error = "Invalid username or password" });
        }

        var token = _tokens.CreateToken(user.Id, user.Username);

        return Ok(new
        {
            token,
            user = new UserOut
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            }
        });
    }

    // ============================
    // FACE LOGIN
    // ============================
    [HttpPost("login-face")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> LoginWithFace([FromForm] FaceLoginRequest request)
    {
        var face = request.Face;
        if (face == null || face.Length == 0)
            return BadRequest(new { error = "Face image is required" });

        using var ms = new MemoryStream();
        await face.CopyToAsync(ms);
        ms.Position = 0;

        var inputEmb = await _fe.GetEmbeddingAsync(ms, face.FileName);

        var embeddings = await _db.FaceEmbeddings.Include(e => e.User).ToListAsync();

        FaceEmbedding? bestMatch = null;
        double bestScore = -1;

        foreach (var emb in embeddings.Where(e => e.Embedding != null && e.Embedding.Length > 0))
        {
            var storedFloats = BytesToFloatArray(emb.Embedding);
            var score = CosineSimilarity(inputEmb, storedFloats);

            if (score > bestScore)
            {
                bestScore = score;
                bestMatch = emb;
            }
        }

        if (bestMatch == null || bestScore < Threshold)
            return Unauthorized(new { error = "Face not recognized", similarity = bestScore });

        var token = _tokens.CreateToken(bestMatch.User.Id, bestMatch.User.Username);

        return Ok(new
        {
            token,
            user = new UserOut
            {
                Id = bestMatch.User.Id,
                Username = bestMatch.User.Username,
                Email = bestMatch.User.Email
            },
            similarity = bestScore
        });
    }

    // ============================
    // REGISTER WITH FACE
    // ============================
    [HttpPost("register")]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<UserOut>> Register([FromForm] RegisterRequest request)
    {
        if (await _db.Users.AnyAsync(u => u.Username == request.Username))
            return BadRequest(new { error = "Username already exists" });

        try
        {
            if (request.Face == null || request.Face.Length == 0)
                return BadRequest(new { error = "Face image is required" });

            using var ms = new MemoryStream();
            await request.Face.CopyToAsync(ms);
            var imageBytes = ms.ToArray();
            ms.Position = 0;

            var emb = await _fe.GetEmbeddingAsync(ms, request.Face.FileName);

            if (emb == null || emb.Length == 0)
            {
                return BadRequest(new { error = "No face embedding generated. Make sure the face is visible and clear." });
            }

            var user = new User
            {
                Username = request.Username,
                Email = request.Email,
                PasswordHash = string.IsNullOrWhiteSpace(request.Password)
                    ? null
                    : BCrypt.Net.BCrypt.HashPassword(request.Password),
                FaceImage = imageBytes
            };

            _db.Users.Add(user);
            await _db.SaveChangesAsync();

            _ = _db.FaceEmbeddings.Add(new FaceEmbedding
            {
                UserId = user.Id,
                Embedding = FloatArrayToBytes(emb) // ✅ store as byte[]
            });
            await _db.SaveChangesAsync();

            return Ok(new UserOut
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email
            });
        }
        catch (ApplicationException ex)
        {
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = ex.Message });
        }
    }

    // ============================
    // HELPERS
    // ============================
    private double CosineSimilarity(float[] a, float[] b)
    {
        if (a.Length != b.Length)
            throw new ArgumentException("Vectors must be the same length");

        double dot = 0, magA = 0, magB = 0;
        for (int i = 0; i < a.Length; i++)
        {
            dot += a[i] * b[i];
            magA += a[i] * a[i];
            magB += b[i] * b[i];
        }

        return dot / (Math.Sqrt(magA) * Math.Sqrt(magB));
    }

    private static float[] BytesToFloatArray(byte[] bytes)
    {
        if (bytes == null || bytes.Length == 0) return Array.Empty<float>();
        var result = new float[bytes.Length / sizeof(float)];
        Buffer.BlockCopy(bytes, 0, result, 0, bytes.Length);
        return result;
    }

    private static byte[] FloatArrayToBytes(float[] array)
    {
        if (array == null || array.Length == 0) return Array.Empty<byte>();
        var result = new byte[array.Length * sizeof(float)];
        Buffer.BlockCopy(array, 0, result, 0, result.Length);
        return result;
    }
}
