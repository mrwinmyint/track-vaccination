using CareBaby.Application.Settings.Emails.Queries;

namespace CareBaby.Application.Common.Contracts.Infrastructure
{
    public interface IEmailService
    {
        Task<bool> SendEmail(EmailDto email);
    }
}