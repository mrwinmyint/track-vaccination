using AutoMapper;
using AutoMapper.QueryableExtensions;
using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Enums;
using MediatR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.ParentUsers.Queries.GetParents;

public record GetParentsQuery : IRequest<ParentsVm>;

public class GetParentsQueryHandler : IRequestHandler<GetParentsQuery, ParentsVm>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetParentsQueryHandler(IApplicationDbContext context,
        IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<ParentsVm> Handle(GetParentsQuery request,
        CancellationToken cancellationToken)
    {
        var parents = new ParentsVm
        {
            Lists = await _context
                        .Users
                        .Where(u => u.Type == (short)UserType.Guardian.Id)
                        .AsNoTracking()
                        .ProjectTo<ParentDto>(_mapper.ConfigurationProvider)
                        .OrderBy(x => x.LastName)
                        .ToListAsync(cancellationToken)
        };                    

        return parents;
    }
}
