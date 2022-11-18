﻿using CareBaby.Application.Common.Mappings;
using CareBaby.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Settings.General.Queries;

public class GeneralSettingsDto : BaseSettingsDto, IMapFrom<SettingGeneral>
{
}
