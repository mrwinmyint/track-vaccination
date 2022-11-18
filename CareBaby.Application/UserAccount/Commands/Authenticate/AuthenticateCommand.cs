using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Enums;
using MediatR;
using Microsoft.Extensions.Logging;
using System.ComponentModel.DataAnnotations;

namespace CareBaby.Application.UserAccount.Commands.Authenticate;

public class AuthenticateCommand : IRequest<AuthenticateCommandResponse<Guid?>>
{
    [Required]
    public string Email { get; set; }

    [Required]
    [DataType(DataType.Password)]
    public string Password { get; set; }
    public bool IsPersistent { get; set; }
}

public class AuthenticateCommandHandler : IRequestHandler<AuthenticateCommand, AuthenticateCommandResponse<Guid?>>
{
    private readonly IIdentityService _identityService;
    private readonly ILogger<AuthenticateCommandHandler> _logger;

    public AuthenticateCommandHandler(IIdentityService identityService,
        ILogger<AuthenticateCommandHandler> logger)
    {
        _identityService = identityService;
        _logger = logger;
    }

    public async Task<AuthenticateCommandResponse<Guid?>> Handle(AuthenticateCommand request, CancellationToken cancellationToken)
    {
        try
        {
            var userName = request.Email;
            var password = request.Password;
            var isPersistent = request.IsPersistent;

            var result = await _identityService.AuthenticateAsync(userName, 
                password,
                isPersistent);

            _logger.LogInformation(result.Message);
            return result;
        }
        catch (Exception ex)
        {
            var errorMessage = $"There was an error while authenticating a user ({request.Email}). Error: {ex.Message}";
            _logger.LogError(errorMessage);
            return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.UserAuthenticatingError, notes: errorMessage);
        }
    }
}