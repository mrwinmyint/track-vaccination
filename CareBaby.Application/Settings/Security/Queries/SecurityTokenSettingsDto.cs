using CareBaby.Application.Common.Mappings;
using CareBaby.Domain.Entities;

namespace CareBaby.Application.Settings.Security.Queries;

public class SecurityTokenSettingsDto : BaseSettingsDto, IMapFrom<SettingSecurityToken>
{
}