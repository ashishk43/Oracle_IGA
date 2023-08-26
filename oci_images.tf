variable "marketplace_source_images" {
  type = map(object({
    ocid = string
    is_pricing_associated = bool
    compatible_shapes = set(string)
  }))
  default = {
    main_mktpl_image = {
      ocid = " ocid1.image.oc1..aaaaaaaam4f6myslzsdpxzualz6logxiwmg2x3cixm23nrbnhaqsrgo43u7a"
      is_pricing_associated = true
      compatible_shapes = []
    }
    }
}
