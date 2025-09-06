using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace FaceAuth.Api.Services
{
    public class EmbeddingResponse
    {
        [JsonPropertyName("embedding")]
        public float[] Embedding { get; set; } = Array.Empty<float>();

        [JsonPropertyName("face_detected")]
        public bool FaceDetected { get; set; }
    }

    public class FaceEmbedderClient
    {
        private readonly HttpClient _http;

        public FaceEmbedderClient(HttpClient http)
        {
            // Ensure base address + timeout are always set
            http.BaseAddress = new Uri("http://127.0.0.1:8000/");
            http.Timeout = TimeSpan.FromMinutes(2);

            _http = http;
        }

        public async Task<float[]> GetEmbeddingAsync(Stream fileStream, string fileName)
        {
            using var content = new MultipartFormDataContent();
            var fileContent = new StreamContent(fileStream);

            // Pick MIME type based on file extension
            string ext = Path.GetExtension(fileName).ToLowerInvariant();
            string mediaType = ext switch
            {
                ".png" => "image/png",
                ".jpg" or ".jpeg" => "image/jpeg",
                _ => "application/octet-stream"
            };
            fileContent.Headers.ContentType = new MediaTypeHeaderValue(mediaType);

            content.Add(fileContent, "file", fileName);

            HttpResponseMessage response;
            try
            {
                response = await _http.PostAsync("embed-face/", content);
            }
            catch (TaskCanceledException ex)
            {
                throw new ApplicationException(
                    "Request to Face API timed out. Check if FastAPI is running and responsive.", ex);
            }
            catch (HttpRequestException ex)
            {
                throw new ApplicationException(
                    "Cannot reach the Face API. Make sure FastAPI is running at http://127.0.0.1:8000", ex);
            }

            var responseBody = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
                throw new ApplicationException($"Face API error ({response.StatusCode}): {responseBody}");

            EmbeddingResponse? result;
            try
            {
                result = JsonSerializer.Deserialize<EmbeddingResponse>(responseBody);
            }
            catch (JsonException ex)
            {
                throw new ApplicationException($"Failed to parse Face API response: {responseBody}", ex);
            }

            if (result == null || !result.FaceDetected || result.Embedding.Length == 0)
                throw new ApplicationException("No valid face embedding returned from Face API.");

            return result.Embedding;
        }

        public static float CosineSimilarity(float[] vectorA, float[] vectorB)
        {
            if (vectorA.Length != vectorB.Length)
                throw new ArgumentException("Vectors must be the same length");

            float dot = 0f, magA = 0f, magB = 0f;

            for (int i = 0; i < vectorA.Length; i++)
            {
                dot += vectorA[i] * vectorB[i];
                magA += vectorA[i] * vectorA[i];
                magB += vectorB[i] * vectorB[i];
            }

            return dot / ((float)Math.Sqrt(magA) * (float)Math.Sqrt(magB));
        }
    }
}
