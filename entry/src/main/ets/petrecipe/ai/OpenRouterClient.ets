import http from '@ohos.net.http';
interface Message { role: string; content: string; }
interface Choice { message?: { content?: string }; }
interface OpenRouterResponse { choices?: Array<Choice>; }

export class OpenRouterClient {
  private readonly endpoint: string = 'https://openrouter.ai/api/v1/chat/completions';
  private readonly model: string = 'openrouter/free';
  // Set this value locally in your DevEco workspace. Never commit a real key.
  private readonly apiKey: string = 'YOUR_OPENROUTER_API_KEY';

  async generate(prompt: string): Promise<string> {
    console.info('[PetRecipe][OpenRouter] START endpoint=' + this.endpoint + ' model=' + this.model);
    console.info('[PetRecipe][OpenRouter] promptLength=' + prompt.length);
    if (this.apiKey === 'YOUR_OPENROUTER_API_KEY' || this.apiKey.length < 20) {
      console.error('[PetRecipe][OpenRouter] API KEY NOT CONFIGURED');
      throw new Error('OpenRouter API key is not configured');
    }

    const client = http.createHttp();
    try {
      const payload: string = JSON.stringify({
        model: this.model,
        messages: [
          { role: 'system', content: 'You are a careful pet nutrition assistant. Return valid JSON only. The recipe is supplementary food, not a replacement for complete pet food or veterinary care.' } as Message,
          { role: 'user', content: prompt } as Message
        ],
        temperature: 0.3
      });
      console.info('[PetRecipe][OpenRouter] POST sending payloadLength=' + payload.length);
      const response = await client.request(this.endpoint, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + this.apiKey,
          'HTTP-Referer': 'https://github.com/lyjuestc/hmdemo1',
          'X-Title': 'Pet Recipe AI MVP'
        },
        extraData: payload,
        connectTimeout: 15000,
        readTimeout: 60000
      });
      const responseText: string = response.result as string;
      console.info('[PetRecipe][OpenRouter] RESPONSE code=' + response.responseCode + ' length=' + responseText.length);
      if (response.responseCode < 200 || response.responseCode >= 300) {
        console.error('[PetRecipe][OpenRouter] HTTP ERROR body=' + responseText.substring(0, 1000));
        throw new Error('OpenRouter HTTP ' + response.responseCode + ': ' + responseText.substring(0, 300));
      }
      let body: OpenRouterResponse;
      try {
        body = JSON.parse(responseText) as OpenRouterResponse;
      } catch (error) {
        console.error('[PetRecipe][OpenRouter] INVALID JSON=' + responseText.substring(0, 1000));
        throw new Error('OpenRouter returned invalid JSON');
      }
      const content: string = body?.choices?.[0]?.message?.content || '';
      if (content.length === 0) {
        console.error('[PetRecipe][OpenRouter] NO CONTENT body=' + responseText.substring(0, 1500));
        throw new Error('OpenRouter returned no message content');
      }
      console.info('[PetRecipe][OpenRouter] SUCCESS contentLength=' + content.length);
      return content;
    } catch (error) {
      console.error('[PetRecipe][OpenRouter] REQUEST FAILED ' + String(error));
      throw error;
    } finally {
      client.destroy();
      console.info('[PetRecipe][OpenRouter] client destroyed');
    }
  }
}
