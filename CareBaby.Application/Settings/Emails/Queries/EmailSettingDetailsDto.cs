namespace CareBaby.Application.Settings.Emails.Queries;
public class EmailSettingDetailsDto
{
    public const string ApiKeyString = "ApiKey";
    public const string FromAddressString = "FromAddress";
    public const string FromNameString = "FromName";

    public string ApiKey { get; set; }
    public string FromAddress { get; set; }
    public string FromName { get; set; }
}