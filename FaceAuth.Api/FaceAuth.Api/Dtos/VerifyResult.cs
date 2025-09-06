namespace FaceAuth.Api.Dtos
{
    public class VerifyResult
    {
        public bool Match { get; set; }
        public UserOut? User { get; set; }
        public double Similarity { get; set; }
        public string? Token { get; set; }
    }
}
