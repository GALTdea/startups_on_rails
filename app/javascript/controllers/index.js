import { application } from "controllers/application"

import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)


// import BottomSheetController from "./bottom_sheet_controller"
// import StickySearchController from "./sticky_search_controller"

// application.register("bottom-sheet", BottomSheetController)
// application.register("sticky-search", StickySearchController)
