using Microsoft.EntityFrameworkCore;
using FaceAuth.Api.Data;
using FaceAuth.Api.Services;

var builder = WebApplication.CreateBuilder(args);

//  Configure SQL Server for AppDbContext
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("Default")));

//  Register FaceEmbedderClient with HttpClient
builder.Services.AddHttpClient<FaceEmbedderClient>(client =>
{
    client.BaseAddress = new Uri("http://127.0.0.1:8000/");
    client.Timeout = TimeSpan.FromMinutes(2);
});

//  Register TokenService
builder.Services.AddScoped<TokenService>();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
