namespace FaceAuth.Api.Models
{
    public class FaceEmbedding
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public byte[] Embedding { get; set; } = Array.Empty<byte>();

        public User User { get; set; } = default!;
    }



}

