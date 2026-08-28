
import http from '@ohos.net.http';
interface Message {
  role: string;
  content: string;
}
interface Choice {
  message?: MessageContent;
}

interface MessageContent {
  content?: string;
}

interface OpenRouterResponse {
  choices?: Array<Choice>;
}

export class OpenRouterClient {
  private readonly endpoint: string = 'https://openrouter.ai/api/v1/chat/completions';
  private readonly model: string = 'openrouter/free';

  // Set this value locally in your DevEco workspace. Do not commit a real API key.
  private readonly apiKey: string = 'YOUR_OPENROUTER_API_KEY';

  async generate(prompt: string): Promise<string> {
    if (this.apiKey === 'YOUR_OPENROUTER_API_KEY') {
      throw new Error('OpenRouter API key is not configured');
    }
    const client = http.createHttp();
    try {
      const response = await client.request(this.endpoint, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.apiKey}`,
          'HTTP-Referer': 'https://github.com/lyjuestc/hmdemo1',
          'X-Title': 'Pet Recipe AI MVP'
        },
        extraData: JSON.stringify({
          model: this.model,
          messages: [
            { role: 'system', content: 'You are a careful pet nutrition assistant. Return valid JSON only. The recipe is supplementary food, not a replacement for complete pet food or veterinary care.' } as Message,
            { role: 'user', content: prompt } as Message
          ],
          temperature: 0.3
        })
      });
      if (response.responseCode < 200 || response.responseCode >= 300) {
        throw new Error(`OpenRouter HTTP ${response.responseCode}`);
      }
      const body: OpenRouterResponse = JSON.parse(response.result as string) as OpenRouterResponse;
      const content: string = body?.choices?.[0]?.message?.content || '';
      if (typeof content !== 'string' || content.length === 0) {
        throw new Error('OpenRouter returned no content');
      }
      return content;
    } finally {
      client.destroy();
    }
  }
}
