using AutoMapper;
using AutoMapper.QueryableExtensions;
using CareBaby.Application.Common.Contracts.Infrastructure;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CareBaby.Application.Settings.General.Queries;

public record GetGeneralSettingsQuery : IRequest<GeneralSettingDetailsDto>;

public class GetGeneralSettingsQueryHandler : IRequestHandler<GetGeneralSettingsQuery, GeneralSettingDetailsDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetGeneralSettingsQueryHandler(IApplicationDbContext context,
        IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<GeneralSettingDetailsDto> Handle(GetGeneralSettingsQuery request,
        CancellationToken cancellationToken)
    {
        var query = new GeneralSettingsVm
        {
            Lists = await _context
                        .SettingGenerals
                        .AsNoTracking()
                        .ProjectTo<GeneralSettingsDto>(_mapper.ConfigurationProvider)
                        .ToListAsync(cancellationToken)
        };

        var settings = new GeneralSettingDetailsDto
        {
            ConfirmEmailCallbackUrl = query.Lists.FirstOrDefault(se => se.Name == GeneralSettingDetailsDto.ConfirmEmailCallbackUrlString)?.Value,  // OK
        };

        return settings;
    }
}