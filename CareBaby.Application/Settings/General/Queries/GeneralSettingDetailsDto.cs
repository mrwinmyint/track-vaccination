using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Settings.General.Queries;

public class GeneralSettingDetailsDto
{
    public const string ConfirmEmailCallbackUrlString = "ConfirmEmailCallbackUrl";

    public string ConfirmEmailCallbackUrl { get; set; }
}