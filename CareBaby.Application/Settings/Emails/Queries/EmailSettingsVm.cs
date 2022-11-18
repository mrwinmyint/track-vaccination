using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Settings.Emails.Queries;
public class EmailSettingsVm
{
    public IList<EmailSettingsDto> Lists { get; set; } = new List<EmailSettingsDto>();
}
