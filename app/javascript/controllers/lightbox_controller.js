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
    console.log("Found lightbox elements:", lightboxLinks.length)
    
    // Prepare elements data for GLightbox
    const elementsData = Array.from(lightboxLinks).map(link => ({
      href: link.href,
      type: 'image',
      title: link.querySelector('img')?.alt || '',
      description: ''
    }))
    
    console.log("Elements data:", elementsData)
    
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
        console.log("Lightbox opened successfully")
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
        console.log("Lightbox closed")
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
    console.log("Opening lightbox at index:", index)
    
    if (this.lightbox) {
      event.preventDefault()
      this.lightbox.openAt(index)
    } else {
      console.error("Lightbox instance not available")
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
