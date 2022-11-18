using CareBaby.Application.Common.Contracts.Infrastructure;
using MediatR.Pipeline;
using Microsoft.Extensions.Logging;

namespace CareBaby.Application.Common.Behaviours;

public class LoggingBehaviour<TRequest> : IRequestPreProcessor<TRequest> where TRequest : notnull
{
    private readonly ILogger _logger;
    private readonly ICurrentUserService _currentUserService;
    private readonly IIdentityService _identityUserRepository;

    public LoggingBehaviour(ILogger<TRequest> logger,
        ICurrentUserService currentUserService,
        IIdentityService identityUserRepository)
    {
        _logger = logger;
        _currentUserService = currentUserService;
        _identityUserRepository = identityUserRepository;
    }

    public async Task Process(TRequest request,
        CancellationToken cancellationToken)
    {
        var requestName = typeof(TRequest).Name;
        var userId = _currentUserService.UserId;
        string userName = string.Empty;

        if (userId.HasValue)
        {
            userName = await _identityUserRepository.GetUserNameAsync(userId.Value);
        }

        _logger.LogInformation($"CareBabyApp Request: {requestName} {userId} {userName} {request}");
    }
}