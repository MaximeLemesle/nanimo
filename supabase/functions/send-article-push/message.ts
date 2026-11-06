const BODY_MAX_LENGTH = 140;

export type Article = { id_article: string; title: string; paragraphs: string[] };

export function truncate(text: string, max = BODY_MAX_LENGTH): string {
  if (text.length <= max) return text;
  return `${text.slice(0, max - 1).trimEnd()}…`;
}

/// `payload` is what `parseArticlePayload` reads back in the app.
export function buildMessage(token: string, article: Article) {
  return {
    message: {
      token,
      notification: {
        title: article.title,
        body: truncate(article.paragraphs[0] ?? ''),
      },
      data: { payload: `article|${article.id_article}` },
      android: { notification: { channel_id: 'articles' } },
    },
  };
}

/// FCM answers 404 UNREGISTERED once an app is gone: that token never works again.
export function isDeadToken(status: number, body: string): boolean {
  return status === 404 && body.includes('UNREGISTERED');
}
