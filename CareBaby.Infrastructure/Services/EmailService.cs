using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Settings.Emails.Queries;
using MediatR;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using SendGrid;
using SendGrid.Helpers.Mail;

namespace CareBaby.Infrastructure.Services;

public class EmailService : IEmailService
{
    public EmailSettingDetailsDto _emailSettings { get; }
    public ILogger<EmailService> _logger { get; }
    public IMediator _mediator;
    public EmailService(ILogger<EmailService> logger,
         IMediator mediator)
    {
        _logger = logger;
        _mediator = mediator;
    }

    public async Task<bool> SendEmail(EmailDto email)
    {
        var emailSettings = await _mediator.Send(new GetEmailSettingsQuery());
        if (emailSettings == null)
        {
            _logger.LogError("Email sending failed. There was an error when retrieving email settings.");
            return false;
        }
        var client = new SendGridClient(emailSettings.ApiKey);

        var subject = email.Subject;
        var to = new EmailAddress(email.To);
        var emailBody = email.Body;

        var from = new EmailAddress
        {
            Email = emailSettings.FromAddress,
            Name = emailSettings.FromName
        };

        var sendGridMessage = MailHelper.CreateSingleEmail(from, to, subject, emailBody, emailBody);
        var response = await client.SendEmailAsync(sendGridMessage);

        _logger.LogInformation("Email sent.");

        if (response.StatusCode == System.Net.HttpStatusCode.Accepted || response.StatusCode == System.Net.HttpStatusCode.OK)
            return true;

        _logger.LogError("Email sending failed.");

        return false;
    }
}