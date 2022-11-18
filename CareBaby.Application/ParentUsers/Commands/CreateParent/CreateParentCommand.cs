using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Entities;
using CareBaby.Domain.Events;
using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.ParentUsers.Commands.CreateParent;

public class CreateParentCommand : IRequest<Guid>
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public DateTimeOffset? DOB { get; set; } = null;
    public string Gender { get; set; } = null;
    public short Type { get; set; } = 1;
    public string Mobile { get; set; }
    public string Address1 { get; set; }
    public bool IsActive { get; set; } = true;
    public bool IsDeleted { get; set; } = false;
    public DateTimeOffset Created { get; set; } = DateTimeOffset.UtcNow;
}

public class CreateParentCommandHandler : IRequestHandler<CreateParentCommand, Guid>
{
    private readonly IApplicationDbContext _context;

    public CreateParentCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<Guid> Handle(CreateParentCommand request, CancellationToken cancellationToken)
    {
        var userEntity = new User 
        {
            Gender = request.Gender,
            Created = request.Created,
            FirstName = request.FirstName,
            LastName = request.LastName,
            Dob = request.DOB,
            Type = request.Type,
            IsActive = request.IsActive,
            IsDeleted = request.IsDeleted
        };

        userEntity.DomainEvents.Add(new ParentCreatedEvent(userEntity));

        _context.Users.Add(userEntity);

        await _context.SaveChangesAsync(cancellationToken);

        return userEntity.Id;
    }
}
