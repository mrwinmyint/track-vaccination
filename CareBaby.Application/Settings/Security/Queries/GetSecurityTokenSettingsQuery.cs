using AutoMapper;
using AutoMapper.QueryableExtensions;
using CareBaby.Application.Common.Contracts.Infrastructure;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.Settings.Security.Queries;
public record GetSecurityTokenSettingsQuery : IRequest<SecurityTokenSettingDetailsDto>;

public record GetSecurityTokenSettingsQueryHandler : IRequestHandler<GetSecurityTokenSettingsQuery, SecurityTokenSettingDetailsDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetSecurityTokenSettingsQueryHandler(IApplicationDbContext context,
        IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<SecurityTokenSettingDetailsDto> Handle(GetSecurityTokenSettingsQuery request,
        CancellationToken cancellationToken)
    {
        var query = new SecurityTokenSettingsVm
        {            
            Lists = await _context.SettingSecurityTokens
                        .AsNoTracking()
                        .ProjectTo<SecurityTokenSettingsDto>(_mapper.ConfigurationProvider)
                        .ToListAsync(cancellationToken)
        };

        int.TryParse(query.Lists.FirstOrDefault(se => se.Name == SecurityTokenSettingDetailsDto.AccessTokenExpiryMinutesString)?.Value, out int accessTokenExpiryMinutes);
        int.TryParse(query.Lists.FirstOrDefault(se => se.Name == SecurityTokenSettingDetailsDto.RefreshTokenExpiryHoursString)?.Value, out int refreshTokenExpiryHours);

        var settings = new SecurityTokenSettingDetailsDto
        {
            Secret = query.Lists.FirstOrDefault(se => se.Name == SecurityTokenSettingDetailsDto.SecretString)?.Value,  // OK
            Audience = query.Lists.FirstOrDefault(se => se.Name == SecurityTokenSettingDetailsDto.AudienceString)?.Value,  // OK
            Issuer = query.Lists.FirstOrDefault(se => se.Name == SecurityTokenSettingDetailsDto.IssuerString)?.Value,  // OK
            AccessTokenExpiryMinutes = accessTokenExpiryMinutes,
            RefreshTokenExpiryHours = refreshTokenExpiryHours
        };

        return settings;
    }
}