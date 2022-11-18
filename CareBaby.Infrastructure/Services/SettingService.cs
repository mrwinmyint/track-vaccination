using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Settings.General.Queries;
using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Infrastructure.Services;

public class SettingService : ISettingService
{
    public ILogger<SettingService> _logger { get; }
    public IMediator _mediator;
    public SettingService(ILogger<SettingService> logger,
         IMediator mediator)
    {
        _logger = logger;
        _mediator = mediator;
    }

    public async Task<GeneralSettingDetailsDto> GetSettings()
    {
        var generalSettings = await _mediator.Send(new GetGeneralSettingsQuery());
        if (generalSettings == null)
        {
            _logger.LogError("Getting settings failed. There was an error when retrieving general settings.");
            return null;
        }

        return generalSettings;
    }
}
