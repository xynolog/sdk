using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog;

internal static class JobCompletion
{
    internal static MarkJobCompleteCommand Mark(JobCompleteCommand completion) =>
        completion is JobCompleteCommand.MarkJobCompleteCommand(var mark) ? mark : throw WrongVerb();

    internal static YieldJobCompleteCommand Yield(JobCompleteCommand completion) =>
        completion is JobCompleteCommand.YieldJobCompleteCommand(var yield) ? yield : throw WrongVerb();

    internal static JobCompleteCommand FromStatus(JobStatusResponse status, ResourceId resource)
    {
        var result = status.Result switch
        {
            null or JobStoredResult.Empty => null,
            JobStoredResult.JobResult(var value) => value,
        };
        return status.Type switch
        {
            JobType.Mark => new JobCompleteCommand.MarkJobCompleteCommand(new MarkJobCompleteCommand
            {
                JobId = status.JobId,
                ResourceId = resource,
                Result = result switch
                {
                    null => null,
                    JobResult.MarkJobDone(var done) => new MarkJobResult.MarkJobDone(done),
                    JobResult.JobDeclined(var declined) => new MarkJobResult.JobDeclined(declined),
                    _ => throw WrongVerb(),
                },
            }),
            JobType.Yield => new JobCompleteCommand.YieldJobCompleteCommand(new YieldJobCompleteCommand
            {
                JobId = status.JobId,
                ResourceId = resource,
                Result = result switch
                {
                    null => null,
                    JobResult.YieldJobDone(var done) => new YieldJobResult.YieldJobDone(done),
                    JobResult.JobDeclined(var declined) => new YieldJobResult.JobDeclined(declined),
                    _ => throw WrongVerb(),
                },
            }),
            _ => throw WrongVerb(),
        };
    }

    internal static JobId Id(JobCompleteCommand completion) => completion switch
    {
        JobCompleteCommand.MarkJobCompleteCommand(var mark) => mark.JobId,
        JobCompleteCommand.YieldJobCompleteCommand(var yield) => yield.JobId,
    };

    private static TransportError WrongVerb() => new(TransportErrorCode.Error, "The job's completion is not the delegated verb's.");
}
