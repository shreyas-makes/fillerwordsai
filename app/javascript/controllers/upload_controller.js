import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "dropzone", 
    "fileInput", 
    "filePreview", 
    "fileName", 
    "progressBar", 
    "progressText", 
    "progressSize", 
    "progressContainer", 
    "submitButton",
    "threshold",
    "thresholdValue"
  ]

  connect() {
    this.resetUI()
    this.updateThresholdValue()
  }

  validate() {
    // Additional validation can be done here
    return true
  }

  updateThresholdValue() {
    if (this.hasThresholdTarget && this.hasThresholdValueTarget) {
      this.thresholdValueTarget.textContent = this.thresholdTarget.value
    }
  }

  dragover(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add("bg-indigo-50")
    this.dropzoneTarget.classList.add("border-indigo-300")
  }

  dragleave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("bg-indigo-50")
    this.dropzoneTarget.classList.remove("border-indigo-300")
  }

  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove("bg-indigo-50")
    this.dropzoneTarget.classList.remove("border-indigo-300")
    
    if (event.dataTransfer.files && event.dataTransfer.files.length > 0) {
      this.fileInputTarget.files = event.dataTransfer.files
      this.fileSelected()
    }
  }

  fileSelected() {
    if (this.fileInputTarget.files && this.fileInputTarget.files.length > 0) {
      const file = this.fileInputTarget.files[0]
      this.fileNameTarget.textContent = file.name
      this.filePreviewTarget.classList.remove("hidden")
      
      // Update file size
      const fileSizeMB = (file.size / (1024 * 1024)).toFixed(1)
      this.progressSizeTarget.textContent = `0.0 MB / ${fileSizeMB} MB`
      
      // Setup direct upload
      this.setupDirectUpload(file)
    }
  }

  removeFile() {
    this.fileInputTarget.value = null
    this.filePreviewTarget.classList.add("hidden")
    this.resetProgress()
  }

  resetUI() {
    this.filePreviewTarget.classList.add("hidden")
    this.resetProgress()
  }

  resetProgress() {
    this.progressBarTarget.style.width = "0%"
    this.progressTextTarget.textContent = "0%"
    this.progressSizeTarget.textContent = "0.0 MB / 0.0 MB"
  }

  setupDirectUpload(file) {
    // This would use ActiveStorage's DirectUpload in a real implementation
    // We're just simulating the progress for this example
    
    // Enable the submit button - in a real implementation, 
    // this would be controlled by the upload completion
    this.submitButtonTarget.disabled = false
    
    // In a real implementation, we would use:
    // const upload = new DirectUpload(file, '/rails/active_storage/direct_uploads')
    // upload.create((error, blob) => {
    //   if (error) {
    //     // Handle error
    //   } else {
    //     // Create a hidden input with the blob ID
    //     const hiddenField = document.createElement('input')
    //     hiddenField.setAttribute("type", "hidden")
    //     hiddenField.setAttribute("value", blob.signed_id)
    //     hiddenField.name = this.fileInputTarget.name
    //     this.element.appendChild(hiddenField)
    //   }
    // })
    // 
    // upload.directUploadWillStoreFileWithXHR = (xhr) => {
    //   xhr.upload.addEventListener("progress", event => {
    //     const progress = event.loaded / event.total * 100
    //     this.progressBarTarget.style.width = `${progress}%`
    //     this.progressTextTarget.textContent = `${Math.round(progress)}%`
    //     
    //     const loadedMB = (event.loaded / (1024 * 1024)).toFixed(1)
    //     const totalMB = (event.total / (1024 * 1024)).toFixed(1)
    //     this.progressSizeTarget.textContent = `${loadedMB} MB / ${totalMB} MB`
    //   })
    // }
  }
} 