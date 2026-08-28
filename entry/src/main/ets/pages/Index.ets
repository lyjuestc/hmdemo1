import { Pet } from '../petrecipe/model/PetModel';
import { Recipe } from '../petrecipe/model/RecipeModel';
import { PetStore } from '../petrecipe/storage/PetStore';
import { RecipeService } from '../petrecipe/service/RecipeService';

@Entry
@Component
struct Index {
  @State screen: string = 'home';
  @State name: string = '';
  @State breed: string = '';
  @State ageMonths: string = '';
  @State weightKg: string = '';
  @State species: 'dog' | 'cat' = 'dog';
  @State status: string = '还没有宠物档案';
  @State recipe: Recipe | null = null;
  @State historyText: string = '暂无历史记录';

  private petStore: PetStore = new PetStore();
  private recipeService: RecipeService = new RecipeService();

  private savePet(): void {
    if (this.name.trim().length === 0 || Number(this.ageMonths) <= 0 || Number(this.weightKg) <= 0) {
      this.status = '请填写有效的名字、年龄和体重';
      return;
    }
    const pet: Pet = {
      id: Date.now().toString(),
      name: this.name.trim(),
      species: this.species,
      breed: this.breed.trim(),
      ageMonths: Number(this.ageMonths),
      weightKg: Number(this.weightKg),
      activityLevel: 'medium',
      allergies: [],
      preferences: []
    };
    this.petStore.save(pet);
    this.status = '宠物档案已保存：' + pet.name;
    this.screen = 'home';
  }

  private async generateRecipe(): Promise<void> {
    const pet: Pet | null = this.petStore.get();
    if (pet === null) {
      this.status = '请先创建宠物档案';
      this.screen = 'pet';
      return;
    }
    this.status = '正在生成食谱...';
    this.screen = 'generate';
    const result: Recipe | null = await this.recipeService.generate(pet);
    if (result === null) {
      this.status = '食谱生成失败，请重试';
      return;
    }
    this.recipe = result;
    this.status = '生成完成';
    this.screen = 'detail';
  }

  private showHistory(): void {
    const items: Recipe[] = this.recipeService.listHistory();
    if (items.length === 0) {
      this.historyText = '暂无历史记录';
    } else {
      this.historyText = items.map((item: Recipe, index: number) => {
        return (index + 1).toString() + '. ' + item.name + '（' + item.status + '）';
      }).join('\n');
    }
    this.screen = 'history';
  }
  @Builder
  private buildHome(): void {
    Column({ space: 18 }) {
      Text('🐾 Pet Recipe AI').fontSize(30).fontWeight(FontWeight.Bold)
      Text('宠物个性化食谱 MVP').fontSize(18)
      Text(this.status).fontSize(16).margin({ top: 8 })
      Button('创建 / 编辑宠物档案').width('90%').onClick(() => this.screen = 'pet')
      Button('生成 AI 食谱').width('90%').onClick(() => this.generateRecipe())
      Button('历史食谱').width('90%').onClick(() => this.showHistory())
    }.padding(24).width('100%')
  }
  @Builder
  private buildPet(): void {
    Column({ space: 12 }) {
      Text('宠物档案').fontSize(28).fontWeight(FontWeight.Bold)
      TextInput({ placeholder: '宠物名字', text: this.name }).onChange((value: string) => this.name = value)
      TextInput({ placeholder: '品种（可选）', text: this.breed }).onChange((value: string) => this.breed = value)
      TextInput({ placeholder: '年龄（月）', text: this.ageMonths }).onChange((value: string) => this.ageMonths = value)
      TextInput({ placeholder: '体重（kg）', text: this.weightKg }).onChange((value: string) => this.weightKg = value)
      Row({ space: 12 }) {
        Button('狗').onClick(() => this.species = 'dog')
        Button('猫').onClick(() => this.species = 'cat')
      }
      Button('保存档案').width('90%').onClick(() => this.savePet())
      Button('返回').width('90%').onClick(() => this.screen = 'home')
      Text(this.status).fontSize(14)
    }.padding(24).width('100%')
  }
  @Builder
  private buildGenerate(): void {
    Column({ space: 20 }) {
      Text('🍲 AI 食谱生成').fontSize(28).fontWeight(FontWeight.Bold)
      Text(this.status).fontSize(18)
      Text('当前为本地 Mock AI 模式，无需 API Key 或网络。').fontSize(14)
      Button('重新生成').onClick(() => this.generateRecipe())
      Button('返回首页').onClick(() => this.screen = 'home')
    }.padding(24).width('100%')
  }
  @Builder
  private buildDetail(): void {
    Column({ space: 14 }) {
      Text('食谱详情').fontSize(28).fontWeight(FontWeight.Bold)
      if (this.recipe !== null) {
        Text(this.recipe.name).fontSize(22).fontWeight(FontWeight.Bold)
        Text('状态：' + this.recipe.status)
        Text('食材').fontSize(18).fontWeight(FontWeight.Bold)
        Text(this.recipe.ingredients.map((item) => item.name + ' · ' + item.amount).join('\n'))
        Text('制作步骤').fontSize(18).fontWeight(FontWeight.Bold)
        Text(this.recipe.steps.map((step, index) => (index + 1).toString() + '. ' + step).join('\n'))
        Text('安全提示').fontSize(18).fontWeight(FontWeight.Bold)
        Text(this.recipe.warnings.join('\n'))
      }
      Button('返回首页').onClick(() => this.screen = 'home')
    }.padding(24).width('100%')
  }
  @Builder
  private buildHistory(): void {
    Column({ space: 18 }) {
      Text('历史食谱').fontSize(28).fontWeight(FontWeight.Bold)
      Text(this.historyText).fontSize(17)
      Button('刷新').onClick(() => this.showHistory())
      Button('返回首页').onClick(() => this.screen = 'home')
    }.padding(24).width('100%')
  }
  build() {
    Scroll() {
      if (this.screen === 'home') {
        this.buildHome()
      } else if (this.screen === 'pet') {
        this.buildPet()
      } else if (this.screen === 'generate') {
        this.buildGenerate()
      } else if (this.screen === 'detail') {
        this.buildDetail()
      } else {
        this.buildHistory()
      }
    }.width('100%').height('100%')
  }
}
