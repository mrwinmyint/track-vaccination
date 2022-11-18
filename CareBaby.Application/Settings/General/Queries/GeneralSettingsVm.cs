using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Settings.General.Queries;
public class GeneralSettingsVm
{
    public IList<GeneralSettingsDto> Lists { get; set; } = new List<GeneralSettingsDto>();
}