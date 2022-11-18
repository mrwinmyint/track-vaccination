using CareBaby.Domain.Common;
using Microsoft.EntityFrameworkCore;
using System.Reflection;

namespace CareBaby.Infrastructure.Configuration
{
    public static class BaseEntityConfiguration
    {
        private static void Configure<TEntity, T>(ModelBuilder modelBuilder) where TEntity : EntityBase<T>
        {
            modelBuilder.Entity<TEntity>(builder =>
            {
                builder.Property(e => e.Id).IsRequired().ValueGeneratedOnAdd();
            });
        }

        public static ModelBuilder ApplyBaseEntityConfiguration(this ModelBuilder modelBuilder)
        {
            var method = typeof(BaseEntityConfiguration).GetTypeInfo().DeclaredMethods
                .Single(m => m.Name == nameof(Configure));

            foreach (var entityType in modelBuilder.Model.GetEntityTypes())
            {
                if (entityType.ClrType.IsBaseEntity(out var T))
                {
                    method.MakeGenericMethod(entityType.ClrType, T).Invoke(null, new[] { modelBuilder });
                }
            }
            return modelBuilder;
        }

        private static bool IsBaseEntity(this Type type, out Type? T)
        {
            for (var baseType = type.BaseType; baseType != null; baseType = baseType.BaseType)
            {
                if (baseType.IsGenericType && baseType.GetGenericTypeDefinition() == typeof(EntityBase<>))
                {
                    T = baseType.GetGenericArguments()[0];
                    return true;
                }
            }
            T = null;
            return false;
        }
    }
}