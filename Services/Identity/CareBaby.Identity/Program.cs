using CareBaby.Application;
using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Common.Models;
using CareBaby.Application.UserAccount.Commands.Authenticate;
using CareBaby.Application.UserAccount.Commands.SignUp;
using CareBaby.Domain.Entities;
using CareBaby.Domain.Identity;
using CareBaby.Identity.Services;
using CareBaby.Infrastructure;
using CareBaby.Infrastructure.Persistence;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData;
using Microsoft.OData.Edm;
using Microsoft.OData.ModelBuilder;

static IEdmModel GetEdmModel()
{
    ODataConventionModelBuilder builder = new();
    var account = builder.EntitySet<ApplicationUser>("Account").EntityType;
    var signUpAction = account.Collection.Action("SignUp");
    signUpAction.Returns<SignUpCommandResponse<Guid?>>();

    var confirmEmailAction = account.Collection.Action("ConfirmEmail");
    signUpAction.Returns<BaseCommandResponse<Guid?>>();

    var signInAction = account.Collection.Action("SignIn");
    signInAction.Returns<AuthenticateCommandResponse<Guid?>>();

    var guardian = builder.EntitySet<User>("Guardians").EntityType;

    return builder.GetEdmModel();
}

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);

builder.Services.AddDatabaseDeveloperPageExceptionFilter();

builder.Services.AddSingleton<ICurrentUserService, CurrentUserService>();

builder.Services.AddHttpContextAccessor();

builder.Services.AddHealthChecks()
    .AddDbContextCheck<ApplicationDbContext>();

// Add services to the container.
builder.Services.AddControllers().AddOData(opt => opt.AddRouteComponents("v1", GetEdmModel()).Filter().Select().Expand());
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new() { Title = "odata", Version = "v1" });
});

// Customise default API behaviour
builder.Services.Configure<ApiBehaviorOptions>(options =>
    options.SuppressModelStateInvalidFilter = true);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "odata v1"));
}

app.UseRouting();
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseIdentityServer();
app.UseAuthorization();

//app.MapControllers();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();