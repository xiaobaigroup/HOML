import { HOMLState, _HOMLState } from "../entryability/AppState"
import { ImageEditViewModel } from "./ImageEditViewModel";
import { Offset, SegmentButtonV2Items, TabSegmentButtonV2 } from "@kit.ArkUI";
import { EventHub, Xb_ImageUtils, Xb_ToastUtil } from "xb_components";
import { fileIo as fs } from "@kit.CoreFileKit";
import { EventKey } from "../common/EventKey";

@Builder
export function ImageEditBuilder(name: string, param: Object) {
  ImageEdit()
}

@ComponentV2
struct ImageEdit {
  @Local viewmodel: ImageEditViewModel = new ImageEditViewModel()
  @Local previewOffset: Offset = { x: 0, y: 0 }
  @Local nowEditIndex: number = 0
  @Local editItems: SegmentButtonV2Items = new SegmentButtonV2Items([
    { text: '竖屏' },
    { text: '横屏' },
  ]);

  // 缩放手势辅助变量
  private lastScale: number = 1.0

  // 拖动手势辅助变量 (用于计算增量)
  @Local lastPanOffsetX: number = 0;
  @Local lastPanOffsetY: number = 0;

  aboutToAppear(): void {
    HOMLState.canClearMainPageInfo = false
    this.loadCacheOrPrompt()
  }

  aboutToDisappear(): void {
    HOMLState.canClearMainPageInfo = true
    this.viewmodel.release()
  }

  async loadCacheOrPrompt() {
    const tempPath = `${_HOMLState.context.filesDir}/temp_edit_image.jpg`;
    try {
      fs.accessSync(tempPath);
      await this.initViewModel(tempPath);
    } catch (e) {
      console.info('[ImageEdit] 未发现图片缓存');
    }
  }

  async initViewModel(imagePath: string) {
    try {
      await this.viewmodel.initialize(
        _HOMLState.context,
        imagePath,
        _HOMLState.windowWidth_px,
        _HOMLState.windowHeight_px
      )
      this.updatePreviewOffset()
    } catch (error) {
      console.error('加载图片失败:', JSON.stringify(error))
      Xb_ToastUtil.showToast({ message: '图片加载失败，请重新选择' })
      try { fs.unlinkSync(imagePath) } catch (e) {}
    }
  }

  async selectImage() {
    try {
      const imagePath = await Xb_ImageUtils.selectOriginalImage2Sand(
        _HOMLState.context,
        'temp_edit_image.jpg'
      )
      if (!imagePath) {
        Xb_ToastUtil.showToast({ message: '取消选择图片' })
        return
      }
      await this.initViewModel(imagePath)
    } catch (error) {
      Xb_ToastUtil.showToast({ message: '加载图片失败' })
    }
  }

  updatePreviewOffset() {
    const offset = this.viewmodel.getOffset()
    this.previewOffset = offset
  }

  build() {
    NavDestination() {
      Flex({ direction: FlexDirection.Column }) {
        if (this.viewmodel.isLoading) {
          LoadingProgress().width(48).height(48)
        } else if (this.viewmodel.previewPixelMap) {
          Column({ space: 10 }) {
            TabSegmentButtonV2({
              items: this.editItems,
              selectedIndex: this.nowEditIndex!!,
              onItemClicked: (tab: number) => {
                this.nowEditIndex = tab;
              }
            })
            this.EditArea()
          }
          .margin(5)
          .padding({ left: 12, right: 12 })
          this.ActionButtons()
        } else {
          Column() {
            Text('请选择一张图片作为背景')
              .fontSize(16)
              .fontColor($r('sys.color.font_secondary'))
            Button('选择图片')
              .margin({ top: 20 })
              .onClick(() => this.selectImage())
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
    }
    .title('编辑背景图片')
    .padding({ top: HOMLState.topRectHeight })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }

  @Builder
  EditArea() {
    Stack() {
      if (this.viewmodel.previewPixelMap) {
        Image(this.viewmodel.previewPixelMap)
          .width(this.viewmodel.baseWidth)
          .height(this.viewmodel.baseHeight)
          .scale({ x: this.viewmodel.currentScale, y: this.viewmodel.currentScale })
          .translate({ x: this.previewOffset.x, y: this.previewOffset.y })
          .objectFit(ImageFit.Fill)
          // 只绑定一个 GestureGroup，同时处理缩放和拖动
          .gesture(
            GestureGroup(GestureMode.Parallel,
              // 缩放手势
              PinchGesture({ fingers: 2 })
                .onActionStart(() => {
                  this.lastScale = this.viewmodel.currentScale;
                })
                .onActionUpdate((event: GestureEvent) => {
                  if (event.scale) {
                    this.viewmodel.setScale(this.lastScale * event.scale);
                    this.updatePreviewOffset();
                  }
                }),
              // 拖动手势
              PanGesture({ fingers: 1, direction: PanDirection.All })
                .onActionStart(() => {
                  // 手势开始时，重置上一次的偏移记录
                  this.lastPanOffsetX = 0;
                  this.lastPanOffsetY = 0;
                })
                .onActionUpdate((event: GestureEvent) => {
                  // event.offsetX 是相对于手势起点的总偏移
                  // 计算增量：本次总偏移 - 上次记录的总偏移
                  const dx = event.offsetX - this.lastPanOffsetX;
                  const dy = event.offsetY - this.lastPanOffsetY;
                  // 将增量传给 ViewModel
                  this.viewmodel.moveImage(dx, dy);
                  this.updatePreviewOffset();
                  // 更新记录，供下一次计算使用
                  this.lastPanOffsetX = event.offsetX;
                  this.lastPanOffsetY = event.offsetY;
                })
            )
          )
      }
      this.CropIndicator()
    }
    .width('100%')
    .layoutWeight(1)
    .clip(true)
    .alignContent(Alignment.Center)
    // 监听容器尺寸变化
    .onAreaChange((oldValue: Area, newValue: Area) => {
      const w = Number(newValue.width);
      const h = Number(newValue.height);
      if (w > 0 && h > 0) {
        this.viewmodel.setContainerSize(w, h);
        // 尺寸更新后，重新校正偏移防止越界
        this.updatePreviewOffset();
      }
    })
  }

  @Builder
  CropIndicator() {
    Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Column() {
        Column() {
          Text(this.nowEditIndex === 0 ? '竖屏' : '横屏')
            .fontSize(12)
            .fontColor(Color.White)
        }
        .width('100%')
        .aspectRatio(
          this.nowEditIndex === 0
            ? _HOMLState.windowWidth_px / _HOMLState.windowHeight_px
            : _HOMLState.windowHeight_px / _HOMLState.windowWidth_px
        )
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 8, bottom: 8 })
        .border({ width: 2, color: Color.White })
        .backgroundColor('rgba(0, 0, 0, 0.3)')
      }
      .width('80%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Transparent)
  }

  @Builder
  ActionButtons() {
    Row() {
      Button('重置')
        .onClick(() => {
          this.viewmodel.resetPosition()
          this.updatePreviewOffset()
        })
      Blank()
      Button('重新选择')
        .onClick(() => this.selectImage())
      Blank()
      Button('保存')
        .onClick(async () => {
          try {
            const isPortrait = this.nowEditIndex === 0;  // 0=竖屏, 1=横屏
            const result = await this.viewmodel.cropAndSave(
              _HOMLState.context,
              _HOMLState.windowWidth_px,
              _HOMLState.windowHeight_px,
              isPortrait
            )
            console.info('ImageEdit 保存成功:', result.path)
            EventHub.sendEvent(EventKey.CustomBackground)
            Xb_ToastUtil.showToast({
              message: result.isPortrait ? '竖屏背景保存成功' : '横屏背景保存成功'
            })
          } catch (error) {
            console.error('ImageEdit 保存失败:', JSON.stringify(error))
            Xb_ToastUtil.showToast({ message: '保存失败' })
          }
        })
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 12 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

}
