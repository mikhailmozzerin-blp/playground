package redisstore

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"

	"github.com/redis/go-redis/v9"
)

// Store wraps a Redis client and stores multiple JSON documents
// under a single key using a Redis Hash.
//
//	key (UUID) -> hash {
//	    field1: json_bytes,
//	    field2: json_bytes,
//	    ...
//	}
type Store struct {
	Client *redis.Client
}

func New(addr string) *Store {
	return &Store{
		Client: redis.NewClient(&redis.Options{Addr: addr}),
	}
}

func (s *Store) Close() error {
	return s.Client.Close()
}

func (s *Store) PutJSON(ctx context.Context, key, field, filePath string) error {
	data, err := os.ReadFile(filePath)
	if err != nil {
		return fmt.Errorf("read file %s: %w", filePath, err)
	}

	if !json.Valid(data) {
		return fmt.Errorf("file %s is not valid JSON", filePath)
	}

	if err := s.Client.HSet(ctx, key, field, data).Err(); err != nil {
		return fmt.Errorf("hset %s/%s: %w", key, field, err)
	}

	log.Printf("stored %s (%d bytes) -> redis hash %s field %q", filePath, len(data), key, field)
	return nil
}

func (s *Store) GetJSON(ctx context.Context, key, field string) (json.RawMessage, error) {
	val, err := s.Client.HGet(ctx, key, field).Bytes()
	if err != nil {
		return nil, fmt.Errorf("hget %s/%s: %w", key, field, err)
	}
	return val, nil
}

func (s *Store) ListFields(ctx context.Context, key string) ([]string, error) {
	return s.Client.HKeys(ctx, key).Result()
}
