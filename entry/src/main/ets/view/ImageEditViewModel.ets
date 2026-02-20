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
  path: string;
  isPortrait: boolean;
}

@ObservedV2
export class ImageEditViewModel {
  private imageSourcePath: string = '';
  private originalWidth: number = 0;
  private originalHeight: number = 0;

  @Trace offsetX: number = 0;
  @Trace offsetY: number = 0;
  @Trace currentScale: number = 1.0;

  private windowFitRatio: number = 1.0;
  private containerFitRatio: number = 1.0;

  @Trace baseWidth: number = 0;
  @Trace baseHeight: number = 0;

  private containerWidth: number = 0;
  private containerHeight: number = 0;

  private windowWidth: number = 0;
  private windowHeight: number = 0;

  previewPixelMap: image.PixelMap | undefined = undefined;

  @Trace isLoading: boolean = false;

  private readonly MIN_SCALE = 0.5;
  private readonly MAX_SCALE = 5.0;

  async initialize(
    context: common.Context,
    imageSourcePath: string,
    windowWidth: number,
    windowHeight: number
  ): Promise<void> {
    this.isLoading = true;
    this.imageSourcePath = imageSourcePath;

    this.windowWidth = windowWidth;
    this.windowHeight = windowHeight;

    this.currentScale = 1.0;
    this.offsetX = 0;
    this.offsetY = 0;

    try {
      const imageSource = image.createImageSource(imageSourcePath);
      const imageInfo = await imageSource.getImageInfo();
      this.originalWidth = imageInfo.size.width;
      this.originalHeight = imageInfo.size.height;

      const ratioW = windowWidth / this.originalWidth;
      const ratioH = windowHeight / this.originalHeight;
      this.windowFitRatio = Math.max(ratioW, ratioH);

      this.calculateBaseSize(windowWidth, windowHeight);

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

  setContainerSize(width: number, height: number) {
    if (width <= 0 || height <= 0) return;
    const isSizeChanged = (Math.abs(this.containerWidth - width) > 1 || Math.abs(this.containerHeight - height) > 1);
    this.containerWidth = width;
    this.containerHeight = height;
    if (isSizeChanged) {
      this.calculateBaseSize(width, height);
      const ratioW = width / this.originalWidth;
      const ratioH = height / this.originalHeight;
      this.containerFitRatio = Math.max(ratioW, ratioH);
    }
  }

  private calculateBaseSize(containerW: number, containerH: number) {
    if (this.originalWidth <= 0 || this.originalHeight <= 0) return;
    const ratioW = containerW / this.originalWidth;
    const ratioH = containerH / this.originalHeight;
    const fitRatio = Math.max(ratioW, ratioH);

    this.baseWidth = this.originalWidth * fitRatio;
    this.baseHeight = this.originalHeight * fitRatio;
  }

  setScale(scale: number): void {
    let newScale = Math.max(this.MIN_SCALE, Math.min(this.MAX_SCALE, scale));
    if (this.currentScale === newScale) return;
    this.currentScale = newScale;
  }

  moveImage(deltaX: number, deltaY: number): void {
    this.offsetX += deltaX;
    this.offsetY += deltaY;
  }

  getOffset(): Offset {
    return { x: this.offsetX, y: this.offsetY };
  }

  private calculateCropRegion(targetWidth: number, targetHeight: number): CropRegion {
    const effectiveFitRatio = this.windowFitRatio;

    const offsetRatioX = this.offsetX / this.containerWidth;
    const offsetRatioY = this.offsetY / this.containerHeight;
    const offsetInOriginalX = offsetRatioX * this.originalWidth;
    const offsetInOriginalY = offsetRatioY * this.originalHeight;

    const cropW_orig = targetWidth / effectiveFitRatio;
    const cropH_orig = targetHeight / effectiveFitRatio;

    const cropCenterX = this.originalWidth / 2 - offsetInOriginalX;
    const cropCenterY = this.originalHeight / 2 - offsetInOriginalY;

    let cropX = cropCenterX - cropW_orig / 2;
    let cropY = cropCenterY - cropH_orig / 2;
    let cropW = cropW_orig;
    let cropH = cropH_orig;

    console.info(`[ImageEdit] 计算结果 (原图坐标系): x=${cropX.toFixed(1)}, y=${cropY.toFixed(1)}, w=${cropW.toFixed(1)}, h=${cropH.toFixed(1)}`);

    if (cropX < 0) {
      cropW = cropW + cropX;
      cropX = 0;
    }
    if (cropY < 0) {
      cropH = cropH + cropY;
      cropY = 0;
    }
    if (cropX + cropW > this.originalWidth) {
      cropW = this.originalWidth - cropX;
    }
    if (cropY + cropH > this.originalHeight) {
      cropH = this.originalHeight - cropY;
    }

    console.info(`[ImageEdit] 边界修正后: x=${cropX.toFixed(1)}, y=${cropY.toFixed(1)}, w=${cropW.toFixed(1)}, h=${cropH.toFixed(1)}`);

    return {
      x: Math.max(0, cropX),
      y: Math.max(0, cropY),
      width: Math.max(1, cropW),
      height: Math.max(1, cropH)
    };
  }

  /**
   * 修改：只保存当前选择的方向
   * @param isPortrait true=竖屏, false=横屏
   */
  async cropAndSave(
    context: common.Context,
    windowW: number,
    windowH: number,
    isPortrait: boolean
  ): Promise<ImageEditResult> {
    if (!this.imageSourcePath) throw new Error("图片路径未初始化");

    let pixelMap: image.PixelMap | undefined = undefined;

    try {
      if (isPortrait) {
        console.debug('[ImageEdit] ========== 竖屏裁切 ==========');
        const region = this.calculateCropRegion(windowW, windowH);
        pixelMap = await this.createAndCropPixelMap(region);
        const path = await this.saveImage(context, pixelMap, `${context.filesDir}/background_portrait.jpg`);
        console.info(`[ImageEdit] 竖屏背景已保存: ${path}`);
        return { path, isPortrait: true };
      } else {
        console.debug('[ImageEdit] ========== 横屏裁切 ==========');
        const region = this.calculateCropRegion(windowH, windowW);
        pixelMap = await this.createAndCropPixelMap(region);
        const path = await this.saveImage(context, pixelMap, `${context.filesDir}/background_landscape.jpg`);
        console.info(`[ImageEdit] 横屏背景已保存: ${path}`);
        return { path, isPortrait: false };
      }
    } finally {
      if (pixelMap) pixelMap.release();
    }
  }

  private async createAndCropPixelMap(region: CropRegion): Promise<image.PixelMap> {
    const imageSource = image.createImageSource(this.imageSourcePath);
    const pixelMap = await imageSource.createPixelMap();
    imageSource.release();

    const cropRegion: image.Region = {
      x: region.x,
      y: region.y,
      size: { width: region.width, height: region.height }
    };

    console.info(`[ImageEdit] 执行裁切:`, JSON.stringify(cropRegion));
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
  }

  release(): void {
    if (this.previewPixelMap) {
      this.previewPixelMap.release();
      this.previewPixelMap = undefined;
    }
  }
}
