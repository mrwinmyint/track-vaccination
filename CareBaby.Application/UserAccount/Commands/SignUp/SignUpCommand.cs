using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Common.Models;
using CareBaby.Application.Settings.Emails.Queries;
using CareBaby.Domain.Enums;
using MediatR;
using Microsoft.Extensions.Logging;

namespace CareBaby.Application.UserAccount.Commands.SignUp;

public class SignUpCommand : BaseUserModel, IRequest<SignUpCommandResponse<Guid?>>
{
    public string Email { get; set; }
    public string Password { get; set; }
}

public class SignUpCommandHandler : IRequestHandler<SignUpCommand, SignUpCommandResponse<Guid?>>
{
    private readonly IIdentityService _identityService;
    private readonly IEmailService _emailService;
    private readonly ISettingService _settingService;
    private readonly ILogger<SignUpCommandHandler> _logger;

    public SignUpCommandHandler(IIdentityService identityService,
        IEmailService emailService,
        ISettingService settingService,
        ILogger<SignUpCommandHandler> logger)
    {
        _identityService = identityService;
        _emailService = emailService;
        _settingService = settingService;
        _logger = logger;
    }

    public async Task<SignUpCommandResponse<Guid?>> Handle(SignUpCommand request, CancellationToken cancellationToken)
    {
        var response = new SignUpCommandResponse<Guid?>();
        try
        {
            var username = request.Email;
            var password = request.Password;
            var firstName = request.FirstName;
            var lastName = request.LastName;

            var result = await _identityService.CreateUserAsync(username, 
                password,
                firstName, 
                lastName);

            if (result.Result.Succeeded)
            {
                _logger.LogInformation($"A user ({result.UserId}) is successfully created.");

                // assign role
                if (!await _identityService.IsInRoleAsync(result.UserId, "Member"))
                {
                    var addedRoleResult = await _identityService.AddToRoleAsync(result.UserId, "Member");

                    if (addedRoleResult.Succeeded)
                    {
                        _logger.LogInformation($"A user ({result.UserId}) is successfully associated with ({UserRole.Member.Name}) role.");
                    }
                }

                // generate and issue token
                var token = await _identityService.GenerateEmailConfirmationTokenAsync(result.UserId);

                await SendEmail(username, token);

                response.Id = result.UserId;
                response.ConfirmationEmailToken = token;
                response.Succeeded = true;
                response.Message = $"The user has been created successfully.";
                return response;
            }
        }
        catch (Exception ex)
        {
            response.Message = $"There was an error while creating a user. Error: {ex.Message}";
        }

        return response;
    }

    private async Task SendEmail(string emailAddress, string token)
    {
        var settings = await _settingService.GetSettings();
        var confirmEmailCallbackUrl = settings.ConfirmEmailCallbackUrl;
        var email = new EmailDto()
        {
            To = emailAddress,
            Body = $"{emailAddress} was signed up.\n Please click the link {confirmEmailCallbackUrl}?ConfirmationEmailToken={token}&Email={emailAddress} to activate your account.",
            Subject = "An account was created"
        };

        try
        {
            await _emailService.SendEmail(email);
        }
        catch (Exception ex)
        {
            _logger.LogError($"Sending email to address ({emailAddress}) failed due to an error with the mail service: {ex.Message}");
        }
    }
}