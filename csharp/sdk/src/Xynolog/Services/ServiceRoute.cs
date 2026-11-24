namespace Xynolog.Services;

/// <summary>An operation of a service's HTTP surface: the method it is asked with, and its path's template.</summary>
public sealed record ServiceRoute(HttpMethod Method, string Path);
