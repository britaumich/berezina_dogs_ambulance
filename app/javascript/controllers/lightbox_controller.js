import { Controller } from "@hotwired/stimulus"
import GLightbox from "glightbox"

export default class extends Controller {
  
  connect() {
    console.log("Lightbox controller connected")
    this.initializeLightbox()
  }
  
  initializeLightbox() {
    // Store reference to the previously focused element
    this.previouslyFocusedElement = null
    
    // Find all lightbox elements within this controller's scope
    const lightboxLinks = this.element.querySelectorAll('.glightbox')    
    // Prepare elements data for GLightbox
    const elementsData = Array.from(lightboxLinks).map(link => ({
      href: link.href,
      type: 'image',
      title: link.querySelector('img')?.alt || '',
      description: ''
    }))
    
    // Initialize GLightbox
    this.lightbox = GLightbox({
      elements: elementsData,
      touchNavigation: true,
      loop: true,
      autoplayVideos: true,
      closeButton: true,
      closeOnOutsideClick: true,
      openEffect: 'zoom',
      closeEffect: 'zoom',
      slideEffect: 'slide',
      moreText: 'View details',
      moreLength: 60,
      onOpen: () => {
        // Store the currently focused element before opening lightbox
        this.previouslyFocusedElement = document.activeElement
        
        // Move focus to the lightbox container or first focusable element
        setTimeout(() => {
          const lightboxContainer = document.getElementById('glightbox-body')
          if (lightboxContainer) {
            const firstFocusable = lightboxContainer.querySelector('.gclose, .gnext, .gprev')
            if (firstFocusable) {
              firstFocusable.focus()
            }
          }
        }, 100)
      },
      onClose: () => {
        // Restore focus to the previously focused element
        if (this.previouslyFocusedElement) {
          this.previouslyFocusedElement.focus()
          this.previouslyFocusedElement = null
        }
      }
    })
  }
  
  openImage(event) {
    const index = parseInt(event.params.index, 10)
    
    if (this.lightbox) {
      event.preventDefault()
      this.lightbox.openAt(index)
    } else {
      if (event.currentTarget && event.currentTarget.href) {
        window.location = event.currentTarget.href
      }
    }
  }
  
  disconnect() {
    if (this.lightbox) {
      this.lightbox.destroy()
    }
  }
}
