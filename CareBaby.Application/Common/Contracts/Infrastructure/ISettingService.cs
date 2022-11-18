using CareBaby.Application.Settings.General.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Common.Contracts.Infrastructure
{
    public interface ISettingService
    {
        Task<GeneralSettingDetailsDto> GetSettings();
    }
}
