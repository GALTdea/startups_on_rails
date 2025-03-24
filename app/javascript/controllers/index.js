import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

import BottomSheetController from "./bottom_sheet_controller"
import StickySearchController from "./sticky_search_controller"

eagerLoadControllersFrom("controllers", application)

application.register("bottom-sheet", BottomSheetController)
application.register("sticky-search", StickySearchController)
