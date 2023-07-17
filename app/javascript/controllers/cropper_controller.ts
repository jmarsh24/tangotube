import { Controller } from '@hotwired/stimulus';
import Cropper from 'cropperjs';
import { getBase64Strings } from 'exif-rotate-js/lib';

// Connects to data-controller="cropper"
export default class extends Controller {
  static targets = ['image', 'input'];
  declare imageTarget: HTMLImageElement;
  declare inputTarget: HTMLInputElement;
  static values = { aspectRatio: Number };
  declare aspectRatioValue: number;
  private cropper!: Cropper;

  connect(): void {
    this.cropper = new Cropper(this.imageTarget, {
      viewMode: 2,
      aspectRatio: this.aspectRatioValue,
      autoCropArea: 1,
      cropend: () => this.updateCrop(),
      ready: () => this.updateCrop(),
    });
  }

  async updateImage(): Promise<void> {
    const file = this.inputTarget.files?.[0];
    if (!file) return;
    const url = (await getBase64Strings([file], {}))[0];

    this.cropper.replace(url);
  }

  private updateCrop(): void {
    this.cropper.getCroppedCanvas({ maxWidth: 1024 }).toBlob(async (blob) => {
      if (!blob) return;
      const imageFile = new File([blob], 'cropped_image.jpg', {
        type: blob.type,
        lastModified: new Date().getTime(),
      });

      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(imageFile);

      this.inputTarget.files = dataTransfer.files;
    }, 'image/jpeg');
  }

  disconnect(): void {
    this.cropper.destroy();
  }
}
