using AutoMapper;
using AutoMapper.QueryableExtensions;
using CareBaby.Application.Common.Contracts.Infrastructure;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace CareBaby.Application.Settings.Emails.Queries;

public record GetEmailSettingsQuery : IRequest<EmailSettingDetailsDto>;

public class GetEmailSettingsQueryHandler : IRequestHandler<GetEmailSettingsQuery, EmailSettingDetailsDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetEmailSettingsQueryHandler(IApplicationDbContext context,
        IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<EmailSettingDetailsDto> Handle(GetEmailSettingsQuery request,
        CancellationToken cancellationToken)
    {
        var query = new EmailSettingsVm
        {
            Lists = await _context
                        .SettingEmails
                        .AsNoTracking()
                        .ProjectTo<EmailSettingsDto>(_mapper.ConfigurationProvider)
                        .ToListAsync(cancellationToken)
        };

        var emailSettings = new EmailSettingDetailsDto
        {
            ApiKey = query.Lists.FirstOrDefault(se => se.Name == EmailSettingDetailsDto.ApiKeyString)?.Value,  // OK
            FromAddress = query.Lists.FirstOrDefault(se => se.Name == EmailSettingDetailsDto.FromAddressString)?.Value, // OK
            FromName = query.Lists.FirstOrDefault(se => se.Name == EmailSettingDetailsDto.FromNameString)?.Value,  // OK
        };

        return emailSettings;
    }
}