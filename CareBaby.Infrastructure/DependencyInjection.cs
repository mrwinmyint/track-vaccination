using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Identity;
using CareBaby.Infrastructure.Identity;
using CareBaby.Infrastructure.Persistence;
using CareBaby.Infrastructure.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CareBaby.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(configuration.GetConnectionString("DefaultConnection")));

        services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());

        services.AddDefaultIdentity<ApplicationUser>(opt => 
        { 
            opt.Lockout.MaxFailedAccessAttempts = 3; 
        })
        .AddRoles<ApplicationRole>()
        .AddEntityFrameworkStores<ApplicationDbContext>();

        services.AddIdentityServer()
            .AddApiAuthorization<ApplicationUser, ApplicationDbContext>();

        services.AddTransient<IDateTimeService, DateTimeService>();
        services.AddTransient<IIdentityService, IdentityService>();
        services.AddTransient<IEmailService, EmailService>();
        services.AddTransient<ISettingService, SettingService>();
        services.AddTransient<IDomainEventService, DomainEventService>();
        services.AddTransient<IHttpService, HttpService>();

        services.AddAuthentication()
            .AddIdentityServerJwt();

        return services;
    }
}