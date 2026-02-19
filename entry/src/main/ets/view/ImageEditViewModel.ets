import { image } from "@kit.ImageKit";
import { fileIo as fs } from "@kit.CoreFileKit";
import { common } from '@kit.AbilityKit';
import { Offset } from "@kit.ArkUI";

export interface CropRegion {
  x: number;
  y: number;
  width: number;
  height: number;
}

export interface ImageEditResult {
  portraitPath: string;
  landscapePath: string;
}

@ObservedV2
export class ImageEditViewModel {
  private imageSourcePath: string = '';
  private originalWidth: number = 0;
  private originalHeight: number = 0;

  // 偏移量：图片中心相对于容器中心的偏移
  @Trace offsetX: number = 0;
  @Trace offsetY: number = 0;

  // 缩放比例 (1.0 = 初始适配屏幕)
  @Trace currentScale: number = 1.0;

  // 预览图基础尺寸 (currentScale = 1.0 时的尺寸)
  @Trace baseWidth: number = 0;
  @Trace baseHeight: number = 0;

  // 容器实际尺寸 (由 UI 层传入)
  private containerWidth: number = 0;
  private containerHeight: number = 0;

  // 预览 PixelMap
  previewPixelMap: image.PixelMap | undefined = undefined;

  @Trace isLoading: boolean = false;

  // 缩放限制
  private readonly MIN_SCALE = 0.5;
  private readonly MAX_SCALE = 5.0;

  async initialize(
    context: common.Context,
    imageSourcePath: string,
    windowWidth: number, // 初始参考宽度
    windowHeight: number // 初始参考高度
  ): Promise<void> {
    this.isLoading = true;
    this.imageSourcePath = imageSourcePath;

    // 重置状态
    this.currentScale = 1.0;
    this.offsetX = 0;
    this.offsetY = 0;

    try {
      const imageSource = image.createImageSource(imageSourcePath);
      const imageInfo = await imageSource.getImageInfo();
      this.originalWidth = imageInfo.size.width;
      this.originalHeight = imageInfo.size.height;

      // 计算初始适配尺寸
      // 默认以高度撑满或宽度撑满为基准 (类似 ImageFit.Cover 的初始状态)
      // 暂时使用传入的 windowWidth/Height 进行初始化，等 UI onAreaChange 触发后会修正
      this.calculateBaseSize(windowWidth, windowHeight);

      // 解码图片
      const decodingOptions: image.DecodingOptions = {
        desiredSize: { width: this.originalWidth, height: this.originalHeight }
      };
      this.previewPixelMap = await imageSource.createPixelMap(decodingOptions);
      imageSource.release();

      this.isLoading = false;
    } catch (error) {
      this.isLoading = false;
      throw new Error('初始化图片失败: ' + JSON.stringify(error));
    }
  }

  /**
   * 设置容器实际尺寸 (由 UI onAreaChange 触发)
   */
  setContainerSize(width: number, height: number) {
    // 避免无效更新
    if (width <= 0 || height <= 0) return;
    const isSizeChanged = (Math.abs(this.containerWidth - width) > 1 || Math.abs(this.containerHeight - height) > 1);
    this.containerWidth = width;
    this.containerHeight = height;
    // 如果是首次获取尺寸或尺寸变化较大，重新计算 baseSize 以适配容器
    if (isSizeChanged) {
      this.calculateBaseSize(width, height);
      // 尺寸变化后，需要修正偏移以防越界
      this.correctOffset();
    }
  }

  /**
   * 计算基础显示尺寸 (ImageFit.Cover 逻辑)
   * 确保 baseWidth/baseHeight 能完全覆盖容器
   */
  private calculateBaseSize(containerW: number, containerH: number) {
    if (this.originalWidth <= 0 || this.originalHeight <= 0) return;
    const ratioW = containerW / this.originalWidth;
    const ratioH = containerH / this.originalHeight;
    // Cover 模式：取较大的比例，确保图片能填满容器
    const fitRatio = Math.max(ratioW, ratioH);
    this.baseWidth = this.originalWidth * fitRatio;
    this.baseHeight = this.originalHeight * fitRatio;
    // 此时 currentScale = 1.0 代表刚好填满容器
  }

  /**
   * 设置缩放比例
   */
  setScale(scale: number): void {
    // 限制缩放范围
    let newScale = Math.max(this.MIN_SCALE, Math.min(this.MAX_SCALE, scale));

    if (this.currentScale === newScale) return;

    this.currentScale = newScale;

    // 缩放改变后，修正偏移量，防止出现黑边
    this.correctOffset();
  }

  /**
   * 核心修复：修正偏移量
   * 逻辑：
   * 如果图片视觉尺寸 < 容器尺寸：强制居中
   * 如果图片视觉尺寸 > 容器尺寸：允许拖动，但不能露出黑边
   */
  private correctOffset(): void {
    if (this.containerWidth === 0 || this.containerHeight === 0) return;
    // 计算当前视觉尺寸
    const visW = this.baseWidth * this.currentScale;
    const visH = this.baseHeight * this.currentScale;

    // 计算 X 轴边界
    if (visW <= this.containerWidth) {
      // 图片宽度 <= 容器宽度，水平居中，不允许左右拖动
      this.offsetX = 0;
    } else {
      // 图片宽度 > 容器宽度，限制拖动范围
      // 最大偏移量 = (图片宽 - 容器宽) / 2
      const maxOX = (visW - this.containerWidth) / 2;
      this.offsetX = Math.max(-maxOX, Math.min(maxOX, this.offsetX));
    }

    // 计算 Y 轴边界
    if (visH <= this.containerHeight) {
      // 图片高度 <= 容器高度，垂直居中
      this.offsetY = 0;
    } else {
      // 图片高度 > 容器高度，限制拖动范围
      const maxOY = (visH - this.containerHeight) / 2;
      this.offsetY = Math.max(-maxOY, Math.min(maxOY, this.offsetY));
    }
  }

  moveImage(deltaX: number, deltaY: number): void {
    // 直接累加偏移
    this.offsetX += deltaX;
    this.offsetY += deltaY;
    // 统一在 correctOffset 中限制边界
    this.correctOffset();
  }

  getOffset(): Offset {
    return { x: this.offsetX, y: this.offsetY };
  }

  /**
   * 计算裁切区域
   * 映射关系：屏幕中心 -> 图片视觉坐标 -> 原图片像素坐标
   */
  private calculateCropRegion(isPortrait: boolean, targetWidth: number, targetHeight: number): CropRegion {
    // 计算 BasePixelMap 到 原图 的比例
    const ratioBaseToOriginal = this.originalWidth / this.baseWidth;

    // 计算目标裁切尺寸映射到 BasePixelMap 上的大小
    // 目标尺寸(屏幕) / currentScale = 视觉尺寸
    const cropW_base = targetWidth / this.currentScale;
    const cropH_base = targetHeight / this.currentScale;

    // 简化计算：
    // 容器中心点就是裁切中心点
    // 裁切中心在图片上的位置 = 图片中心 - 偏移量
    // 容器中心坐标 (相对于容器左上角)
    const containerCenterX = this.containerWidth / 2;
    const containerCenterY = this.containerHeight / 2;

    // 转换到图片视觉坐标系
    const picX = (this.containerWidth - this.baseWidth * this.currentScale) / 2 + this.offsetX;
    const picY = (this.containerHeight - this.baseHeight * this.currentScale) / 2 + this.offsetY;
    // 裁切框中心在图片视觉坐标系中的位置：
    const cropCenterX_vis = containerCenterX - picX;
    const cropCenterY_vis = containerCenterY - picY;
    // 转回 BasePixelMap 坐标系 (除以 scale)
    const cropCenterX_base = cropCenterX_vis / this.currentScale;
    const cropCenterY_base = cropCenterY_vis / this.currentScale;
    // 计算左上角
    let cropXP_base = cropCenterX_base - cropW_base / 2;
    let cropYP_base = cropCenterY_base - cropH_base / 2;
    // 边界检查 (防止计算出负值)
    cropXP_base = Math.max(0, cropXP_base);
    cropYP_base = Math.max(0, cropYP_base);
    let finalW = cropW_base;
    let finalH = cropH_base;
    if (cropXP_base + finalW > this.baseWidth) finalW = this.baseWidth - cropXP_base;
    if (cropYP_base + finalH > this.baseHeight) finalH = this.baseHeight - cropYP_base;
    // 映射回原图坐标系
    return {
      x: cropXP_base * ratioBaseToOriginal,
      y: cropYP_base * ratioBaseToOriginal,
      width: finalW * ratioBaseToOriginal,
      height: finalH * ratioBaseToOriginal
    };
  }

  async cropAndSave(context: common.Context, windowW: number, windowH: number): Promise<ImageEditResult> {
    if (!this.imageSourcePath) throw new Error("图片路径未初始化");
    let portraitPM: image.PixelMap | undefined = undefined;
    let landscapePM: image.PixelMap | undefined = undefined;
    try {
      // 竖屏裁切
      const pRegion = this.calculateCropRegion(true, windowW, windowH);
      portraitPM = await this.createAndCropPixelMap(pRegion);
      // 横屏裁切
      const lRegion = this.calculateCropRegion(false, windowH, windowW);
      landscapePM = await this.createAndCropPixelMap(lRegion);
      const basePath = context.filesDir;
      const pPath = await this.saveImage(context, portraitPM, `${basePath}/background_portrait.jpg`);
      const lPath = await this.saveImage(context, landscapePM, `${basePath}/background_landscape.jpg`);
      return { portraitPath: pPath, landscapePath: lPath };
    } finally {
      if (portraitPM) portraitPM.release();
      if (landscapePM) landscapePM.release();
    }
  }

  private async createAndCropPixelMap(region: CropRegion): Promise<image.PixelMap> {
    const imageSource = image.createImageSource(this.imageSourcePath);
    // 裁切时加载原图以保证画质
    const pixelMap = await imageSource.createPixelMap();
    imageSource.release();
    const cropRegion: image.Region = {
      x: region.x,
      y: region.y,
      size: { width: region.width, height: region.height }
    };
    await pixelMap.crop(cropRegion);
    return pixelMap;
  }

  private async saveImage(context: common.Context, pixelMap: image.PixelMap, destPath: string): Promise<string> {
    const imagePacker = image.createImagePacker();
    const packOptions: image.PackingOption = { format: 'image/jpeg', quality: 95 };
    const packedData = await imagePacker.packing(pixelMap, packOptions);
    imagePacker.release();
    const file = fs.openSync(destPath, fs.OpenMode.CREATE | fs.OpenMode.WRITE_ONLY);
    fs.writeSync(file.fd, packedData);
    fs.closeSync(file);
    return destPath;
  }

  resetPosition(): void {
    this.offsetX = 0;
    this.offsetY = 0;
    this.currentScale = 1.0;
    this.correctOffset();
  }

  release(): void {
    if (this.previewPixelMap) {
      this.previewPixelMap.release();
      this.previewPixelMap = undefined;
    }
  }
}
