class DbSchema {
  static const dbName = 'lara.db';
  static const dbVersion = 1;

  static const chatsTable = 'chats';
  static const messagesTable = 'messages';

  static const createChats =
      '''
CREATE TABLE $chatsTable (
  localId TEXT PRIMARY KEY,
  remoteId TEXT,
  title TEXT NOT NULL,
  personality TEXT NOT NULL,
  date INTEGER NOT NULL,
  isTyping INTEGER NOT NULL,
  lastMessageId TEXT
);
''';

  static const createMessages =
      '''
CREATE TABLE $messagesTable (
  id TEXT PRIMARY KEY,
  chatId TEXT NOT NULL,
  content TEXT NOT NULL,
  createdAt INTEGER NOT NULL,
  isFromUser INTEGER NOT NULL,
  status INTEGER NOT NULL,
  remoteId TEXT,
  FOREIGN KEY (chatId) REFERENCES $chatsTable(localId) ON DELETE CASCADE
);
''';

  static const createIndexes =
      '''
CREATE INDEX idx_chats_date ON $chatsTable(date DESC);
CREATE INDEX idx_messages_chat_created ON $messagesTable(chatId, createdAt DESC);
CREATE INDEX idx_messages_status ON $messagesTable(status);
''';
}
