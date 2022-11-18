using CareBaby.Application.Common.Mappings;
using CareBaby.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Settings.Emails.Queries;

public class EmailSettingsDto : BaseSettingsDto, IMapFrom<SettingEmail>
{
}