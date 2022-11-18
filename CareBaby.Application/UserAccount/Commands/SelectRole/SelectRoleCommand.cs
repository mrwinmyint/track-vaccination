using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Enums;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.UserAccount.Commands.SelectRole;

public class SelectRoleCommand : IRequest<SelectRoleCommandResponse<Guid?>>
{
    [Required]
    public string Email { get; set; }

    [Required]
    public string Role { get; set; }

    [Required]
    public string Token { get; set; }
}

public class SelectRoleCommandHandler : IRequestHandler<SelectRoleCommand, SelectRoleCommandResponse<Guid?>>
{
    private readonly IIdentityService _identityService;
    private readonly ILogger<SelectRoleCommandHandler> _logger;

    public SelectRoleCommandHandler(IIdentityService identityService,
        ILogger<SelectRoleCommandHandler> logger)
    {
        _identityService = identityService;
        _logger = logger;
    }

    public async Task<SelectRoleCommandResponse<Guid?>> Handle(SelectRoleCommand request, CancellationToken cancellationToken)
    {
        try
        {
            var userName = request.Email;
            var role = request.Role;
            var token = request.Token;

            var result = await _identityService.VerifyRoleSelectionTokenAsync(userName,
                role,
                token);

            _logger.LogInformation(result.Message);
            return result;
        }
        catch (Exception ex)
        {
            var errorMessage = $"There was an error while authenticating a user ({request.Email}). Error: {ex.Message}";
            _logger.LogError(errorMessage);
            return SelectRoleCommandResponse<Guid?>.Failure(ValidationError.UserAuthenticatingError, notes: errorMessage);
        }
    }
}
