package state

import (
	"github.com/hashicorp/consul/agent/consul/stream"
	memdb "github.com/hashicorp/go-memdb"
)

// topicHandlers describes the methods needed to process a streaming
// subscription for a given topic.
type topicHandlers struct {
	Snapshot       func(*stream.SubscribeRequest, *stream.EventBuffer) (uint64, error)
	ProcessChanges func(*txn, memdb.Changes) ([]stream.Event, error)
}

// topicRegistry is a map of topic handlers. It must only be written to during
// init().
var topicRegistry map[stream.Topic]topicHandlers

func init() {
	topicRegistry = map[stream.Topic]topicHandlers{
		// For now we don't actually support subscribing to ACL* topics externally
		// so these have no Snapshot methods yet. We do need to have a
		// ProcessChanges func to publish the partial events on ACL changes though
		// so that we can invalidate other subscriptions if their effective ACL
		// permissions change.
		stream.Topic_ACLTokens: {
			ProcessChanges: aclEventsFromChanges,
		},
		// Note no ACLPolicies/ACLRoles defined yet because we publish all events
		// from one handler to save on iterating/filtering and duplicating code and
		// there are no snapshots for these yet per comment above.
	}
}
