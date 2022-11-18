using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Common.Models;
using MediatR;

namespace CareBaby.Application.UserAccount.Commands.ConfirmEmail;

public class ConfirmEmailCommand : IRequest<BaseCommandResponse<Guid?>>
{
    public string Email { get; set; }
    public string Token { get; set; }
}

public class ConfirmEmailCommandHandler : IRequestHandler<ConfirmEmailCommand, BaseCommandResponse<Guid?>>
{
    private readonly IIdentityService _identityService;

    public ConfirmEmailCommandHandler(IIdentityService identityService)
    {
        _identityService = identityService;
    }

    public async Task<BaseCommandResponse<Guid?>> Handle(ConfirmEmailCommand request, CancellationToken cancellationToken)
    {
        var response = new BaseCommandResponse<Guid?>();
        try
        {
            var email = request.Email;
            var token = request.Token;

            var result = await _identityService.ConfirmEmailAsync(email, token);

            if (result.Succeeded)
            {
                response.Succeeded = true;
                response.Message = $"The email has been confirmed successfully.";
                return response;
            }
        }
        catch (Exception ex)
        {
            response.Message = $"There was an error while confirming the email. Error: {ex.Message}";
        }

        return response;
    }
}