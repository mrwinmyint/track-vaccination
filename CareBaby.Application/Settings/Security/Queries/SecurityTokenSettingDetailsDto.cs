namespace CareBaby.Application.Settings.Security.Queries;

public class SecurityTokenSettingDetailsDto
{
    public const string SecretString = "Secret";
    public const string AudienceString = "Audience";
    public const string IssuerString = "Issuer";
    public const string AccessTokenExpiryMinutesString = "AccessTokenExpiryMinutes";
    public const string RefreshTokenExpiryHoursString = "RefreshTokenExpiryHours";

    public string Secret { get; set; }
    public string Audience { get; set; }
    public string Issuer { get; set; }
    public int AccessTokenExpiryMinutes { get; set; } = 0;
    public int RefreshTokenExpiryHours { get; set; } = 0;
}