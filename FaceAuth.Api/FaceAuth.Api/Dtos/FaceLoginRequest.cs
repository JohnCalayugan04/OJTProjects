using Microsoft.AspNetCore.Mvc;

namespace FaceAuth.Api.Dtos
{
    public class FaceLoginRequest
    {
        [FromForm(Name = "face")]
        public IFormFile Face { get; set; } = null!;
    }

}
