namespace FaceAuth.Api.Dtos
{
    public class VerifyRequest
    {
        public IFormFile Face { get; set; } = default!;
        public string? Username { get; set; }
    }
}
