using FluentValidation;
using MediatR;
using ValidationException = CareBaby.Application.Common.Exceptions.ValidationException;

namespace CareBaby.Application.Common.Behaviours;

public class ValidationBehaviour<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse>
     where TRequest : IRequest<TResponse>
{
    private readonly IEnumerable<IValidator<TRequest>> _validators;

    public ValidationBehaviour(IEnumerable<IValidator<TRequest>> validators)
    {
        _validators = validators;
    }

    public async Task<TResponse> Handle(TRequest request,
        CancellationToken cancellationToken,
        RequestHandlerDelegate<TResponse> next)
    {
        if (_validators.Any())
        {
            var context = new ValidationContext<TRequest>(request);

            var validaitonResults = await Task.WhenAll(_validators.Select(v => v.ValidateAsync(context, cancellationToken)));

            var failures = validaitonResults
                .Where(vr => vr.Errors.Any())
                .SelectMany(vr => vr.Errors)
                .ToList();

            if (failures.Any())
            {
                throw new ValidationException(failures);
            }
        }

        return await next();
    }
}