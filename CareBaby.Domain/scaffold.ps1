if ($PWD.Provider.Name -eq 'FileSystem') {
    [System.IO.Directory]::SetCurrentDirectory($PWD)
}

$noBom = New-Object System.Text.UTF8Encoding $False

$project = [IO.File]::ReadAllText("CareBaby.Data.csproj")
[IO.File]::WriteAllText("./CareBaby.Data.csproj" , $project, $noBom)

dotnet ef dbcontext scaffold "Server=localhost;Database=CareBabyDevDb;Trusted_Connection=True;" Microsoft.EntityFrameworkCore.SqlServer -o Entities --context-dir '.' -f -c CareDbContextGenerated --no-onconfiguring
Start-Sleep -Milliseconds 250

$junk = @"

#nullable disable

"@

$newLine = @"

"@

$contextPath = "./CareDbContextGenerated.cs"
# apply require dll libraries
 @( 
 "using CareBaby.Data.Identity;", 
 "using Microsoft.AspNetCore.Identity;", 
 "using Microsoft.AspNetCore.Identity.EntityFrameworkCore;") +  (Get-Content $contextPath -Raw) | Set-Content $contextPath
$context = Get-Content $contextPath -Raw

$context = $context -replace "using Microsoft.EntityFrameworkCore.Metadata;`r`n", ""
$context = $context -replace $junk, $newLine
# replace default DbContext
$context = $context -replace ": DbContext", ": IdentityDbContext<ApplicationUsers
                                                            , ApplicationRoles
                                                            , Guid
                                                            , IdentityUserClaim<Guid>
                                                            , ApplicationUserRoles
                                                            , ApplicationUserLogins
                                                            , IdentityRoleClaim<Guid>
                                                            , IdentityUserToken<Guid>>"

$context = $context -replace "DbContextOptions<CareDbContextGenerated>", "DbContextOptions"
# remove AspNet properties
$context = $context -replace "public virtual DbSet<AspNetRoleClaim> AspNetRoleClaims { get; set; } = null!;`r`n", ""
$context = $context -replace "public virtual DbSet<AspNetRole> AspNetRoles { get; set; } = null!;`r`n", ""
$context = $context -replace "public virtual DbSet<AspNetUserClaim> AspNetUserClaims { get; set; } = null!;`r`n", ""
$context = $context -replace "public virtual DbSet<AspNetUserRole> AspNetUserRoles { get; set; } = null!;`r`n", ""
$context = $context -replace "public virtual DbSet<AspNetUser> AspNetUsers { get; set; } = null!;`r`n", "`r`n"

# correct default naming
$context = $context -replace "ActionedByNavigation", "User"
$context = $context -replace "IdNavigation", "AspNetUsers"
$context = $context -replace "\.IdNavigation", "\.AspNetUsers"

[IO.File]::WriteAllText($contextPath, $context, $noBom)

Move-Item -Path $contextPath -Destination "./DataContext/CareDbContext.Generated.cs" -Force
Start-Sleep -Milliseconds 250

# add base.OnModelCreating(modelBuilder);
$fileName = "./DataContext/CareDbContext.Generated.cs"
$pattern = "modelBuilder.Entity<ActionLog>"
[System.Collections.ArrayList]$generatedFile = Get-Content $fileName
$insert = @()

for ($i=0; $i -lt $generatedFile.count; $i++) {
  if ($generatedFile[$i] -match $pattern) {
    $insert += $i-0 #Record the position of the line before this one
  }
}

# now loop the recorded array positions and insert the new text
$insert | Sort-Object -Descending | ForEach-Object { $generatedFile.insert($_,"`t`t`tbase.OnModelCreating(modelBuilder);`r`n") }

Set-Content $fileName $generatedFile


Remove-Item -Path "./Entities/AspNetRole.cs"
Remove-Item -Path "./Entities/AspNetUserRoles.cs"
Remove-Item -Path "./Entities/AspNetUser.cs"
Remove-Item -Path "./Entities/AspNetUserClaim.cs"
Remove-Item -Path "./Entities/AspNetRoleClaim.cs"

$files = Get-ChildItem "./Entities" *.cs -rec
foreach ($file in $files)
{      
    $modelPath = $file.FullName
    # if the file is in User.cs or RefreshToken, it needs using CareBaby.Data.Identity;
    if (($modelPath -match 'Entities\\User') -or 
    ($modelPath -match 'Entities\\RefreshToken'))
    {
        @("using CareBaby.Data.Base;", "using CareBaby.Data.Identity;") +  (Get-Content $modelPath -Raw) | Set-Content $modelPath
    }
    else
    {
        @("using CareBaby.Data.Base;") +  (Get-Content $modelPath -Raw) | Set-Content $modelPath
    }
    $model = Get-Content $modelPath -Raw

    $model = $model -replace "public partial class ([a-zA-Z0-9]+)`r`n", $('public partial class $1 : EntityBase<Guid>' + "`r`n")  
    $model = $model -replace "public Guid Id { get; set; }`r`n", ""
    $model = $model -replace "public bool IsActive { get; set; }`r`n", ""
    $model = $model -replace "public bool IsDeleted { get; set; }`r`n", ""
    $model = $model -replace "public DateTimeOffset Created { get; set; }`r`n", ""
    $model = $model -replace "public Guid\? CreatedById { get; set; }`r`n", ""
    $model = $model -replace "public string CreatedByName { get; set; }`r`n", ""
    $model = $model -replace "public DateTimeOffset\? LastModified { get; set; }`r`n", ""
    $model = $model -replace "public Guid\? LastModifiedById { get; set; }`r`n", ""
    $model = $model -replace "public string LastModifiedByName { get; set; }`r`n", ""
    $model = $model -replace "ActionedByNavigation`r`n", "User" 
    $model = $model -replace "public virtual CustomEntity Entity { get; set; }`r`n", "public virtual CustomEntity CustomEntity { get; set; }`r`n"
    $model = $model -replace "public virtual AspNetUser IdNavigation { get; set; } = null!;`r`n", "public virtual ApplicationUsers AspNetUsers { get; set; }`r`n"
    $model = $model -replace "public virtual AspNetUser User { get; set; } = null!;`r`n", "public virtual ApplicationUsers User { get; set; }`r`n"
    $model = $model -replace "public virtual User\? ActionedByNavigation { get; set; }`r`n", "public virtual User? User { get; set; }`r`n"
           
    $model = $model -replace $junk, ""
    [IO.File]::WriteAllText($modelPath, $model, $noBom)
}
Start-Sleep -Milliseconds 250

$project = $project -replace "(?s)`r`n\s*$"

[IO.File]::WriteAllText("./CareBaby.Data.csproj", $project, $noBom)

dotnet format CareBaby.Data.csproj