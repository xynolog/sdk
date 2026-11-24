public func sortOpenResources(_ resources: [OpenResource]) -> [OpenResource] {
  resources.sorted { ($0.order, $0.openedAt) < ($1.order, $1.openedAt) }
}

public func applyTabChecks(
  _ resources: [OpenResource], checks: [ResourceId: TabCheck]
) -> [OpenResource] {
  resources.compactMap { resource in
    guard let check = checks[resource.id] else { return resource }
    switch check {
    case .gone: return nil
    case .unknown: return resource
    case .ready(let ready):
      var refreshed = resource
      refreshed.name = ready.name
      if let mediaType = ready.mediaType, !mediaType.isEmpty { refreshed.mediaType = mediaType }
      return refreshed
    }
  }
}

func checkOpenResource(_ client: XynologClient, id: ResourceId) async -> TabCheck {
  do {
    let descriptor = try await client.browse.resource(id).fresh()
    return .ready(TabCheckReady(mediaType: primaryMediaType(descriptor), name: descriptor.name))
  } catch let error as BusRequestError where error.reason == .busNotFound {
    return .gone(TabCheckGone())
  } catch {
    return .unknown(TabCheckUnknown())
  }
}
