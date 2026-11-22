#if !NET11_0_OR_GREATER
namespace System.Runtime.CompilerServices;

// What C# 15 marks a closed class with, which .NET 11 defines and .NET 10
// does not: the generated unions are closed records (Generated/Types), and
// the compiler takes the attribute from the assembly it compiles when the
// framework lacks it.
internal sealed class IsClosedTypeAttribute : Attribute;
#endif
