export class OpenRouterClient {
  async generate(prompt: string): Promise<string> {
    return JSON.stringify({
      status: 'warning',
      name: '鸡肉南瓜营养碗',
      type: 'supplementary',
      ingredients: [
        { name: '熟鸡胸肉', amount: '50g' },
        { name: '南瓜', amount: '30g' },
        { name: '胡萝卜', amount: '20g' }
      ],
      steps: [
        '将鸡胸肉彻底煮熟并去骨',
        '南瓜和胡萝卜蒸熟后切碎',
        '混合食材并充分冷却后喂食'
      ],
      warnings: [
        '当前为 MVP Mock AI，不调用网络',
        '辅助餐不替代完整宠粮或兽医建议'
      ]
    });
  }
}
